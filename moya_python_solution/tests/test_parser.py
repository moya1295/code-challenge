import pytest
import json
from src.parser import GoogleArtworksParser


# Helper func to read html files
def read_html(filepath: str) -> str:
    with open(filepath, "r", encoding="utf-8") as f:
        return f.read()


# Run tests on all files inside html_files/
@pytest.mark.parametrize(
        "html_filepath", 
        [
            ("html_files/van-gogh-paintings.html"),
            ("html_files/sample_1.html"),
            ("html_files/sample_2.html"),
            ("html_files/sample_3.html")
        ]
    )
def test_artwork_parser(html_filepath):
    html = read_html(html_filepath)
    parser = GoogleArtworksParser(html=html)
    result = parser.parse_artworks()
    # convert json object to python dict
    result = json.loads(result)
    
    # Test the the parser does not return None
    assert result is not None

    # Test artworks is of type list
    assert isinstance(result["artworks"], list)

    # Test that we extracted at least one artwork
    assert len(result["artworks"]) > 0

    # Test that each artwork has the expected fields and values are not None
    for artwork in result["artworks"]:
        assert artwork["name"] is not None
        assert artwork["extensions"] is not None
        assert artwork["link"] is not None
        assert artwork["image"] is not None

    # Test that each value is of correct type
    for artwork in result["artworks"]:
        assert isinstance(artwork["name"], str)
        assert isinstance(artwork["extensions"], list)
        assert isinstance(artwork["link"], str)
        assert isinstance(artwork["image"], str)

    # Test that we extract atleast 4 img base64 str eg. 'datadata:image/jpeg;base64'
    count = 0
    for artwork in result['artworks']:
        if "data:image/jpeg;base64" in artwork['image']:
            count = count + 1
    assert count >= 4
