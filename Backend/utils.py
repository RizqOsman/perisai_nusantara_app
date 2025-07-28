import uuid
from datetime import datetime
import base64
from io import BytesIO
from PIL import Image

def generate_unique_id():
    """Generate unique ID for various entities"""
    return str(uuid.uuid4())

def generate_visitor_number():
    """Generate visitor number with format VT-YYYYMMDD-XXXX"""
    today = datetime.now().strftime("%Y%m%d")
    random_suffix = str(uuid.uuid4())[:4].upper()
    return f"VT-{today}-{random_suffix}"

def generate_package_id():
    """Generate package ID with format PK-YYYYMMDD-XXXX"""
    today = datetime.now().strftime("%Y%m%d")
    random_suffix = str(uuid.uuid4())[:4].upper()
    return f"PK-{today}-{random_suffix}"

def generate_report_id():
    """Generate report ID with format RP-YYYYMMDD-XXXX"""
    today = datetime.now().strftime("%Y%m%d")
    random_suffix = str(uuid.uuid4())[:4].upper()
    return f"RP-{today}-{random_suffix}"

def generate_activity_id():
    """Generate activity ID with format AC-YYYYMMDD-XXXX"""
    today = datetime.now().strftime("%Y%m%d")
    random_suffix = str(uuid.uuid4())[:4].upper()
    return f"AC-{today}-{random_suffix}"

def compress_image_base64(base64_string, max_size=(800, 600), quality=85):
    """Compress base64 image and return compressed base64 string"""
    try:
        # Remove data URL prefix if present
        if base64_string.startswith('data:'):
            base64_string = base64_string.split(',')[1]
        
        # Decode base64 to image
        image_data = base64.b64decode(base64_string)
        image = Image.open(BytesIO(image_data))
        
        # Convert to RGB if necessary
        if image.mode != 'RGB':
            image = image.convert('RGB')
        
        # Resize image
        image.thumbnail(max_size, Image.Resampling.LANCZOS)
        
        # Save to bytes with compression
        buffer = BytesIO()
        image.save(buffer, format='JPEG', quality=quality, optimize=True)
        compressed_data = buffer.getvalue()
        
        # Encode back to base64
        compressed_base64 = base64.b64encode(compressed_data).decode('utf-8')
        
        return compressed_base64
    except Exception as e:
        print(f"Error compressing image: {e}")
        # Return original string if compression fails
        if not base64_string.startswith('data:'):
            return f"data:image/jpeg;base64,{base64_string}"
        return base64_string

def validate_phone_number(phone):
    """Validate Indonesian phone number format"""
    import re
    # Remove spaces, dashes, and plus signs
    phone = re.sub(r'[\s\-+]', '', phone)
    
    # Check if it's a valid Indonesian phone number
    # Format: 08xxxxxxxxxx or 628xxxxxxxxxx
    pattern = r'^(08|\+?628)\d{8,11}$'
    return bool(re.match(pattern, phone))

def format_phone_number(phone):
    """Format phone number to standard Indonesian format"""
    import re
    # Remove all non-digit characters except +
    phone = re.sub(r'[^\d+]', '', phone)
    
    # If starts with 08, convert to 628
    if phone.startswith('08'):
        phone = '62' + phone[1:]
    
    # If doesn't start with +62, add it
    if not phone.startswith('+62'):
        phone = '+62' + phone
    
    return phone

def get_current_datetime():
    """Get current datetime in ISO format"""
    return datetime.now().isoformat()

def parse_datetime_string(datetime_str):
    """Parse datetime string to datetime object"""
    try:
        # Try different formats
        formats = [
            "%Y-%m-%dT%H:%M:%S.%fZ",
            "%Y-%m-%dT%H:%M:%SZ",
            "%Y-%m-%d %H:%M:%S",
            "%Y-%m-%d"
        ]
        
        for fmt in formats:
            try:
                return datetime.strptime(datetime_str, fmt)
            except ValueError:
                continue
        
        # If all formats fail, return current datetime
        return datetime.now()
    except Exception:
        return datetime.now() 