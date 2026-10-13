#!/usr/bin/env python3
"""Validate the public portfolio content contract before a Hosting deploy."""

import json
import sys
from pathlib import Path
from urllib.parse import urlparse


CONTENT_PATH = Path(__file__).resolve().parents[1] / "content/v1/projects.json"
PROJECT_FIELDS = {"id", "priority", "title", "description", "imageUrl", "links"}
LINK_TYPES = {"launch", "download", "source"}


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


def validate() -> None:
    content = json.loads(CONTENT_PATH.read_text(encoding="utf-8"))
    if not isinstance(content, dict) or content.get("schemaVersion") != 1:
        raise ValueError("content must be an object with schemaVersion: 1")
    projects = content.get("projects")
    if not isinstance(projects, list):
        raise ValueError('"projects" must be an array')

    ids: set[str] = set()
    ordering: list[tuple[int, str]] = []
    for index, project in enumerate(projects):
        label = f"projects[{index}]"
        if not isinstance(project, dict) or set(project) != PROJECT_FIELDS:
            raise ValueError(f"{label} must contain exactly {sorted(PROJECT_FIELDS)}")
        project_id = require_string(project["id"], f"{label}.id")
        if project_id in ids:
            raise ValueError(f"duplicate project id: {project_id}")
        ids.add(project_id)
        priority = project["priority"]
        if not isinstance(priority, int) or isinstance(priority, bool):
            raise ValueError(f"{label}.priority must be an integer")
        ordering.append((priority, project_id))
        require_string(project["title"], f"{label}.title")
        require_string(project["description"], f"{label}.description")
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
        raise ValueError('projects must be ordered by "priority", then "id"')


if __name__ == "__main__":
    try:
        validate()
    except (OSError, json.JSONDecodeError, ValueError) as error:
        print(f"Content validation failed: {error}", file=sys.stderr)
        raise SystemExit(1) from error
    print(f"Validated {len(json.loads(CONTENT_PATH.read_text(encoding='utf-8'))['projects'])} projects.")
