#!/usr/bin/env python3
"""Validate both public portfolio content contracts before a Hosting deploy."""

import json
import sys
from pathlib import Path
from urllib.parse import urlparse


ROOT = Path(__file__).resolve().parents[1]
V1_PATH = ROOT / "content/v1/projects.json"
V2_PATH = ROOT / "content/v2/projects.json"
V1_FIELDS = {"id", "priority", "title", "description", "imageUrl", "links"}
V2_FIELDS = {"id", "priority", "title", "descriptions", "technologies", "imageUrl", "links"}
LINK_TYPES = {"launch", "download", "source"}
LOCALES = {"pt", "en"}


def require_string(value: object, label: str) -> str:
    if not isinstance(value, str) or not value.strip():
        raise ValueError(f"{label} must be a non-empty string")
    return value


def require_http_url(value: object, label: str) -> str:
    url = require_string(value, label)
    parsed = urlparse(url)
    if parsed.scheme not in {"http", "https"} or not parsed.netloc:
        raise ValueError(f"{label} must be an absolute HTTP(S) URL")
    return url


def validate_envelope(content: object, version: int, path: Path) -> list[dict]:
    if not isinstance(content, dict) or content.get("schemaVersion") != version:
        raise ValueError(f'{path.relative_to(ROOT)} must have schemaVersion: {version}')
    projects = content.get("projects")
    if not isinstance(projects, list):
        raise ValueError(f'{path.relative_to(ROOT)} "projects" must be an array')

    fields = V1_FIELDS if version == 1 else V2_FIELDS
    ids: set[str] = set()
    ordering: list[tuple[int, str]] = []
    for index, project in enumerate(projects):
        label = f"{path.relative_to(ROOT)} projects[{index}]"
        if not isinstance(project, dict) or set(project) != fields:
            raise ValueError(f"{label} must contain exactly {sorted(fields)}")
        project_id = require_string(project["id"], f"{label}.id")
        if project_id in ids:
            raise ValueError(f"duplicate project id in {path.relative_to(ROOT)}: {project_id}")
        ids.add(project_id)
        priority = project["priority"]
        if not isinstance(priority, int) or isinstance(priority, bool):
            raise ValueError(f"{label}.priority must be an integer")
        ordering.append((priority, project_id))
        require_string(project["title"], f"{label}.title")
        if version == 1:
            require_string(project["description"], f"{label}.description")
        else:
            descriptions = project["descriptions"]
            if not isinstance(descriptions, dict) or set(descriptions) != LOCALES:
                raise ValueError(f'{label}.descriptions must contain exactly "pt" and "en"')
            for locale in sorted(LOCALES):
                paragraphs = descriptions[locale]
                if not isinstance(paragraphs, dict) or set(paragraphs) != {"concept", "implementation"}:
                    raise ValueError(f'{label}.descriptions.{locale} must contain exactly "concept" and "implementation"')
                for paragraph in ("concept", "implementation"):
                    require_string(paragraphs[paragraph], f"{label}.descriptions.{locale}.{paragraph}")

            technologies = project["technologies"]
            if not isinstance(technologies, list):
                raise ValueError(f"{label}.technologies must be an array")
            normalized: set[str] = set()
            for tag_index, tag in enumerate(technologies):
                value = require_string(tag, f"{label}.technologies[{tag_index}]")
                folded = value.strip().casefold()
                if folded in normalized:
                    raise ValueError(f"{label}.technologies contains duplicate tag: {value}")
                normalized.add(folded)

        require_http_url(project["imageUrl"], f"{label}.imageUrl")
        links = project["links"]
        if not isinstance(links, list):
            raise ValueError(f"{label}.links must be an array")
        for link_index, link in enumerate(links):
            link_label = f"{label}.links[{link_index}]"
            if not isinstance(link, dict) or set(link) != {"type", "url"}:
                raise ValueError(f'{link_label} must contain exactly "type" and "url"')
            link_type = require_string(link["type"], f"{link_label}.type")
            if link_type not in LINK_TYPES:
                raise ValueError(f"{link_label}.type is unsupported: {link_type}")
            require_http_url(link["url"], f"{link_label}.url")

    if ordering != sorted(ordering):
        raise ValueError(f'{path.relative_to(ROOT)} projects must be ordered by "priority", then "id"')
    return projects


def validate() -> int:
    v1 = validate_envelope(json.loads(V1_PATH.read_text(encoding="utf-8")), 1, V1_PATH)
    v2 = validate_envelope(json.loads(V2_PATH.read_text(encoding="utf-8")), 2, V2_PATH)
    if len(v1) != len(v2):
        raise ValueError("v1 and v2 project metadata must describe the same projects")
    shared_fields = ("id", "priority", "title", "imageUrl", "links")
    for index, (legacy, bilingual) in enumerate(zip(v1, v2)):
        if any(legacy[field] != bilingual[field] for field in shared_fields):
            raise ValueError(f"v1 and v2 project metadata differs at index {index}")
    return len(v2)


if __name__ == "__main__":
    try:
        count = validate()
    except (OSError, json.JSONDecodeError, ValueError) as error:
        print(f"Content validation failed: {error}", file=sys.stderr)
        raise SystemExit(1) from error
    print(f"Validated v1 and v2 content for {count} projects.")
