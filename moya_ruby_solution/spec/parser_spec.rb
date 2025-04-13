require_relative '../lib/parser'

describe GoogleArtworksParser do
  Dir.glob("sample_html_files/*.html").each do |file_path|
    context "Parsing file: #{File.basename(file_path)}" do
      before :all do
        @html_from_file = File.read(file_path, encoding: "utf-8")
        @parser = GoogleArtworksParser.new(@html_from_file)
        @results = @parser.parse
      end

      it "results should be a hash" do
        expect(@results).to be_a(Hash)
      end

      it "should contain an 'artworks' array and have a minimum of 20 artworks" do
        expect(@results[:artworks]).to be_an(Array)
        expect(@results[:artworks].length).to be >= 4
      end

      it "should have at least 4 images encoded as 'data:image'" do
        base64_images = @results[:artworks].select { |artwork| artwork[:image].start_with?("data:image") }
        expect(base64_images.length).to be >= 4
      end

      context "Iterate over each artwork in artworks" do
        it "each artwork should have the correct schema" do
          @results[:artworks].each_with_index do |artwork, i|
            expect(artwork).to be_a(Hash), "Artwork ##{i} is not a Hash"

            expect(artwork[:name]).to be_a(String)
            expect(artwork[:name]).not_to be_empty

            expect(artwork[:image]).to be_a(String)
            expect(artwork[:image]).not_to be_empty
            valid_image = artwork[:image].start_with?("data:image") || artwork[:image].start_with?("https://")
            expect(valid_image).to be(true), "Artwork ##{i} has invalid image: #{artwork[:image]}"

            expect(artwork[:extensions]).to be_an(Array)
            expect(artwork[:extensions]).not_to be_empty

            expect(artwork[:link]).to be_a(String)
            expect(artwork[:link]).not_to be_empty
            expect(artwork[:link]).to start_with("https://www.google.com")
          end
        end
      end
    end
  end
end
