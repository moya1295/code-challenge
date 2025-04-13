# Google Artwork parser solution for serp api code challenge
# Author: Muhammad Owais
# Date: 10-April-2025


require 'nokogiri'
require 'json'

class GoogleArtworksParser

  def initialize(html_content=nil)
    @google_host = "https://www.google.com"
    @doc = Nokogiri::HTML(html_content)
  end

  def parse
    { artworks: extract_all_artworks}.to_json
  end

  def extract_all_artworks
    # iterate over all artworks div containers and extract title, link, extensions and image
    @doc.css('div.iELo6').map do |artwork_div|
      {
        name: extract_artwork_name(artwork_div),
        link: extract_artwork_link(artwork_div),
        extensions: extract_artwork_extensions(artwork_div),
        image: extract_artwork_image(artwork_div)
      }
    end
  end

  def extract_artwork_name(artwork_div)
    name_div = artwork_div.at_css('div.pgNMRc')
    name_div.text
  end

  def extract_artwork_link(artwork_div)
    link = artwork_div.at_css('a')&.[]('href')
    return nil unless link
    link.start_with?(@google_host) ? link : "#{@google_host}#{link}"
  end

  def extract_artwork_extensions(artwork_div)
    extensions_div = artwork_div.at_css('div.cxzHyb')
    [extensions_div.text]
  end

  def extract_artwork_image(artwork_div)
    attr_data_src_value = artwork_div.at_css('img.taFZJe')&.[]('data-src')
    attr_id_value = artwork_div.at_css('img.taFZJe')&.[]('id')
    return attr_data_src_value unless attr_id_value
    extract_img_base64_str(attr_id_value)
  end

  def extract_img_base64_str(attr_id_value)
    @doc.css('script').each do |script|
      content = script.text
      next unless content.include?(attr_id_value)
      if match = content.match(/var\s+s\s*=\s*'([^']+)'/)
        return unescape_hex_chars(match[1])
      end
    end
    nil
  end

  def unescape_hex_chars(encoded_string)
    encoded_string.gsub(/\\x([0-9a-fA-F]{2})/) { [$1].pack('H*') }
  end
end


# Example usage
if __FILE__ == $PROGRAM_NAME
  html = File.read("sample_html_files/van-gogh-paintings.html", encoding: "utf-8")
  parser = GoogleArtworksParser.new(html)
  result = parser.parse
  puts JSON.pretty_generate(JSON.parse(result))
end