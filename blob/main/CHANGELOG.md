# Changelog

All notable changes to Pine UI will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.3] - 2025-05-07

### Added

- New components:
  - Accordion components: `accordion_item`, `accordion_group`
  - Tabs components: `tabs`, `tabs_pills`, `tabs_boxed`
  - Modal components: `modal`, `modal_full_screen`, `modal_side`
  - Switch components: `switch`, `switch_labeled`, `switch_card`
  - Dropdown components: `dropdown`, `dropdown_with_icons`, `context_menu`
  - Progress components: `progress_bar`, `progress_circle`, `progress_steps`
  - Pagination components: `pagination`, `pagination_simple`, `pagination_load_more`
  - Toast components: `toast_container`, `toast`, `toast_trigger`
  - File upload components: `file_uploader`, `image_uploader`, `multi_file_uploader`
  - Image gallery components: `image_gallery`, `image_gallery_masonry`, `image_carousel`
  - Data table components: `data_table`, `data_table_expandable`
  - Date picker components: `date_picker`, `date_range_picker`

- Improved documentation and component grouping in ExDoc

## [0.1.0] - 2023-03-29

### Added

- Initial release with the following components:
  - Text components: typing_effect, text_animation_blow, text_animation_fade
  - Tooltip component with top, left, and right variants
  - Button components: primary, secondary, danger with loading states
  - Badge components: basic, dot, dismissible
  - Card components: basic, interactive, collapsible
  - Select components: basic, grouped, searchable
  - TextInput components: basic, with_icon, textarea
- Documentation and examples
- Comprehensive test suite
