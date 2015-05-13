require "minitest/autorun"
require "editor_config"
require "stringio"

class TestParse < MiniTest::Test
  def fixture(name)
    path = File.join(__dir__, "fixtures/#{name}")
    File.read(path)
  end

  def test_parse_example
    assert_equal([
      {
        "*" => {
          "end_of_line" => "lf",
          "insert_final_newline" => "true"
        },
        "*.{js,py}" => {
          "charset" => "utf-8"
        },
        "*.py" => {
          "indent_style" => "space",
          "indent_size" => "4"
        },
        "Makefile" => {
          "indent_style" => "tab"
        },
        "lib/**.js" => {
          "indent_style" => "space",
          "indent_size" => "2"
        },
        "{package.json,.travis.yml}" => {
          "indent_style" => "space",
          "indent_size" => "2"
        }
      },
      true
    ], EditorConfig.parse(fixture(:sample)))
  end

  def test_parse_example_file_io
    path = File.join(__dir__, "fixtures/sample")
    assert_equal([
      {
        "*" => {
          "end_of_line" => "lf",
          "insert_final_newline" => "true"
        },
        "*.{js,py}" => {
          "charset" => "utf-8"
        },
        "*.py" => {
          "indent_style" => "space",
          "indent_size" => "4"
        },
        "Makefile" => {
          "indent_style" => "tab"
        },
        "lib/**.js" => {
          "indent_style" => "space",
          "indent_size" => "2"
        },
        "{package.json,.travis.yml}" => {
          "indent_style" => "space",
          "indent_size" => "2"
        }
      },
      true
    ], EditorConfig.parse(File.open(path)))
  end

  def test_parse_example_string_io
    assert_equal([
      {
        "*" => {
          "end_of_line" => "lf",
          "insert_final_newline" => "true"
        },
        "*.{js,py}" => {
          "charset" => "utf-8"
        },
        "*.py" => {
          "indent_style" => "space",
          "indent_size" => "4"
        },
        "Makefile" => {
          "indent_style" => "tab"
        },
        "lib/**.js" => {
          "indent_style" => "space",
          "indent_size" => "2"
        },
        "{package.json,.travis.yml}" => {
          "indent_style" => "space",
          "indent_size" => "2"
        }
      },
      true
    ], EditorConfig.parse(StringIO.new(fixture(:sample))))
  end

  def test_parse_max_section_name
    config, _ = EditorConfig.parse(fixture(:max_section_name))
    assert_equal [
      [100, 100],
      [500, 500],
      [500, 600]
    ], config.map { |name, value| [name.bytesize, value["length"].to_i] }
  end

  def test_parse_max_property_name
    config, _ = EditorConfig.parse(fixture(:max_property_name))
    assert_equal [
      [100, 100],
      [500, 500],
      [500, 600]
    ], config["Makefile"].map { |name, value| [name.bytesize, value.to_i] }
  end
end