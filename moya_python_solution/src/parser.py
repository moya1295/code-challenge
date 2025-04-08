from parsel import Selector
import re
import json
from rich import print_json
from typing import Optional, Dict, List, Any, Union


class GoogleArtworksParser:
    
    HOST = "https://www.google.com"

    def __init__(self, html: str) -> None:
        """Initialize parser with HTML str and create Selector object."""
        self.html = html
        self.selector = Selector(text=html)
    
    def find_img_base64_encoded_str(self, image_id: str) -> Optional[str]:
        """ 
            Using id attr value from img tag,
            we find script tags with matching ii var and extract image base64 str usign regex.
            Function input: image_id (str)
            Function output: image_base64 (str) or None if not found
        """
        try:
            # Select all script tags
            script_tags = self.selector.css('script ::text').getall()
            # Find script tag which has our desired image_id inside var 'ii' and extract encoded str from var 's' using regex
            for script_content in script_tags:
                if image_id in script_content:
                    s_match = re.search(r"var\s+s\s*=\s*'([^']+)'", script_content)
                    if s_match:
                        encoded_str = s_match.group(1)
                        # Unescape the hexadecimal characters like \x3d
                        decoded_str = encoded_str.encode().decode('unicode_escape')
                        return decoded_str
            # If not found return None
            return None
        except Exception as e:
            print(f"An error occured while finding image encoded str: The error: {e}")
            return None


    def parse_artworks(self) -> Dict[str, List[Dict[str, Union[str, List[str]]]]]:
        """
        All artworks related carousel data is inside div with class = 'iELo6'
        We Iterate over all of these containers and extract required artworks data
        Input: HTML selector object
        Output: Json Object with an array of each individual artwork data object
        """
        try:
            artwork_data_lst = []
            # Select all div containers for artwork classes.
            artworks_container = self.selector.css('div.iELo6')

            # Iterate over all artwork containers and extract name, link, extension, img  
            for artwork in artworks_container:
                
                # Extract link
                link = artwork.css('a ::attr(href)').get()
                if self.HOST not in link:
                    link = self.HOST + link
                
                # Extract Name
                name = artwork.css('div.pgNMRc ::text').get()

                # Extract extension
                extensions = artwork.css('div.cxzHyb ::text').getall()

                # Extract image link
                image_data_src = artwork.css('img.taFZJe ::attr(data-src)').get()
                image_id = artwork.css('img.taFZJe ::attr(id)').get()
                # If image id exists, find base64-encoded image str from script tags else default to image data-src link.
                if image_id is not None:
                    image_link = self.find_img_base64_encoded_str(image_id=image_id)
                else:
                    image_link = image_data_src
                
                # Append artwork data to master list
                artwork_data_lst.append({
                    'name'      : name,
                    'extensions': extensions,
                    'link'      : link,
                    'image'     : image_link
                })
            
            return json.dumps({'artworks' : artwork_data_lst})

        except Exception as e:
            print(f"An error occured while parsing. The error: {e}")
            return json.dumps({'artworks': []})


# Test and print output
if __name__ == "__main__":
    with open("html_files/van-gogh-paintings.html", "r", encoding="utf-8") as f:
        html = f.read()
    parser = GoogleArtworksParser(html=html)
    result = parser.parse_artworks()
    print_json(result)