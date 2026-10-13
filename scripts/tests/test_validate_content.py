import copy
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch


SCRIPT = Path(__file__).resolve().parents[1] / "validate_content.py"
SPEC = importlib.util.spec_from_file_location("validate_content", SCRIPT)
validator = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(validator)


class ContentValidationTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.v1 = json.loads(validator.V1_PATH.read_text(encoding="utf-8"))
        cls.v2 = json.loads(validator.V2_PATH.read_text(encoding="utf-8"))

    def validate_pair(self, v1, v2):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            legacy, bilingual = root / "v1.json", root / "v2.json"
            legacy.write_text(json.dumps(v1), encoding="utf-8")
            bilingual.write_text(json.dumps(v2), encoding="utf-8")
            with patch.multiple(validator, ROOT=root, V1_PATH=legacy, V2_PATH=bilingual):
                return validator.validate()

    def test_current_content_is_valid(self):
        self.assertEqual(self.validate_pair(self.v1, self.v2), 7)

    def test_project_count_mismatch_is_rejected(self):
        changed = copy.deepcopy(self.v2)
        changed["projects"].pop()
        with self.assertRaisesRegex(ValueError, "same projects"):
            self.validate_pair(self.v1, changed)

    def test_each_shared_metadata_field_must_match(self):
        for field, value in {
            "id": "Different-id", "priority": -1, "title": "Different title",
            "imageUrl": "https://example.test/image.png",
            "links": [{"type": "source", "url": "https://example.test"}],
        }.items():
            with self.subTest(field=field):
                changed = copy.deepcopy(self.v2)
                changed["projects"][0][field] = value
                with self.assertRaisesRegex(ValueError, "metadata differs"):
                    self.validate_pair(self.v1, changed)

    def test_translation_and_tag_errors_are_rejected(self):
        invalid = []
        missing = copy.deepcopy(self.v2)
        del missing["projects"][0]["descriptions"]["en"]
        invalid.append(missing)
        blank = copy.deepcopy(self.v2)
        blank["projects"][0]["descriptions"]["en"]["implementation"] = " "
        invalid.append(blank)
        for tags in [["Dart", " dart "], [""], [3], "Dart"]:
            changed = copy.deepcopy(self.v2)
            changed["projects"][0]["technologies"] = tags
            invalid.append(changed)
        for content in invalid:
            with self.subTest(content=content):
                with self.assertRaises(ValueError):
                    self.validate_pair(self.v1, content)

    def test_empty_tags_are_valid(self):
        changed = copy.deepcopy(self.v2)
        changed["projects"][0]["technologies"] = []
        self.assertEqual(self.validate_pair(self.v1, changed), 7)


if __name__ == "__main__":
    unittest.main()
