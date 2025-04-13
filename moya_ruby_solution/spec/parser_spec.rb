require_relative '../lib/parser'

describe GoogleArtworksParser do
  let(:html) { File.read("sample_html_files/van-gogh-paintings.html", encoding: "utf-8") }
  let(:parser) { GoogleArtworksParser.new(html) }

  describe '#initialize' do
    it 'creates a new parser instance' do
      expect(parser).to be_a(GoogleArtworksParser)
    end

    it 'accepts HTML content' do
      expect { GoogleArtworksParser.new(html) }.not_to raise_error
    end

    it 'handles nil input' do
      expect { GoogleArtworksParser.new(nil) }.not_to raise_error
    end
  end

  describe '#parse' do
    let(:parsed_result) { JSON.parse(parser.parse) }

    it 'returns JSON string' do
      expect(parser.parse).to be_a(String)
      expect { JSON.parse(parser.parse) }.not_to raise_error
    end

    it 'contains artworks key in result' do
      expect(parsed_result).to have_key('artworks')
    end

    it 'extracts multiple artworks' do
      expect(parsed_result['artworks'].length).to be > 0
    end
  end

  describe '#extract_all_artworks' do
    let(:artworks) { parser.extract_all_artworks }

    it 'returns an array of artwork hashes' do
      expect(artworks).to be_an(Array)
      expect(artworks.first).to be_a(Hash)
    end

    it 'each artwork has required keys' do
      artwork = artworks.first
      expect(artwork).to have_key(:name)
      expect(artwork).to have_key(:link)
      expect(artwork).to have_key(:extensions)
      expect(artwork).to have_key(:image)
    end
  end

  describe '#extract_artwork_name' do
    it 'extracts the correct artwork name' do
      # Create a fixture for testing a single artwork div
      artwork_div = parser.instance_variable_get(:@doc).at_css('div.iELo6')
      name = parser.extract_artwork_name(artwork_div)
      expect(name).to be_a(String)
      expect(name).not_to be_empty
    end
  end

  describe '#extract_artwork_link' do
    it 'extracts and formats the link correctly' do
      artwork_div = parser.instance_variable_get(:@doc).at_css('div.iELo6')
      link = parser.extract_artwork_link(artwork_div)
      expect(link).to be_a(String)
      expect(link).to start_with('https://www.google.com')
    end

    it 'handles missing links gracefully' do
      # Create a mock div without a link
      mock_div = Nokogiri::HTML('<div></div>').at_css('div')
      link = parser.extract_artwork_link(mock_div)
      expect(link).to be_nil
    end
  end

  describe '#extract_artwork_extensions' do
    it 'returns an array with extension text' do
      artwork_div = parser.instance_variable_get(:@doc).at_css('div.iELo6')
      extensions = parser.extract_artwork_extensions(artwork_div)
      expect(extensions).to be_an(Array)
      expect(extensions.first).to be_a(String)
    end
  end

  describe '#extract_artwork_image' do
    it 'extracts image source' do
      artwork_div = parser.instance_variable_get(:@doc).at_css('div.iELo6')
      image = parser.extract_artwork_image(artwork_div)
      expect(image).not_to be_nil
    end
  end

  describe '#unescape_hex_chars' do
    it 'correctly unescapes hex characters' do
      hex_string = "Test \\x41\\x42\\x43" # ABC in hex
      result = parser.unescape_hex_chars(hex_string)
      expect(result).to eq("Test ABC")
    end
  end
end