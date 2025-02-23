import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime

# Initialize Firebase Admin with your service account key.
# the services account key is level up in the folder structure
cred = credentials.Certificate('serviceAccountKey.json')  # <-- Update this path
firebase_admin.initialize_app(cred)

# Get a reference to the Firestore client.
db = firestore.client()

# Sample data for the 'articles' collection.
articles = [
    {
        "title": "Master Your Finances with Holdwise",
        "description": "Discover smart budgeting strategies and personal finance tips using Holdwise’s powerful tools.",
        "imageUrl": "https://example.com/images/holdwise_finances.jpg",
        "url": "https://example.com/articles/master-your-finances",
        "author": "Jane Smith",
        "category": "Personal Finance",
        "timestamp": datetime.fromisoformat("2025-02-16T12:00:00")
    },
    {
        "title": "Investing 101: Getting Started with Holdwise",
        "description": "A beginner’s guide to investing wisely with Holdwise—learn how to build your portfolio with confidence.",
        "imageUrl": "https://example.com/images/holdwise_investing.jpg",
        "url": "https://example.com/articles/investing-101",
        "author": "Mark Johnson",
        "category": "Investing",
        "timestamp": datetime.fromisoformat("2025-02-15T15:30:00")
    },
    {
        "title": "5 Ways Holdwise Can Help You Save More",
        "description": "Explore five actionable tips to boost your savings and manage your expenses with Holdwise.",
        "imageUrl": "https://example.com/images/holdwise_savings.jpg",
        "url": "https://example.com/articles/5-ways-to-save",
        "author": "Emily Davis",
        "category": "Savings",
        "timestamp": datetime.fromisoformat("2025-02-14T10:15:00")
    }
]

# Sample data for the 'advices' collection.
advices = [
    {
        "title": "Automate Your Savings",
        "content": "Set up automatic transfers with Holdwise to ensure you save a portion of your income each month.",
        "type": "text",
        "mediaUrl": None,
        "author": "Financial Expert",
        "category": "Savings",
        "timestamp": datetime.fromisoformat("2025-02-16T09:00:00")
    },
    {
        "title": "Visualize Your Budget",
        "content": "Use Holdwise’s interactive charts to get a clear picture of your spending habits.",
        "type": "image",
        "mediaUrl": "https://example.com/images/budget_chart.jpg",
        "author": "Budget Guru",
        "category": "Budgeting",
        "timestamp": datetime.fromisoformat("2025-02-15T14:00:00")
    },
    {
        "title": "Investing Tips for Beginners",
        "content": "Watch this quick video for expert tips on starting your investment journey with Holdwise.",
        "type": "video",
        "mediaUrl": "https://example.com/videos/investing_tips.mp4",
        "author": "Investment Advisor",
        "category": "Investing",
        "timestamp": datetime.fromisoformat("2025-02-14T11:45:00")
    }
]

def upload_documents(collection_name, documents):
    """Upload a list of documents to a Firestore collection."""
    for doc in documents:
        # Create a new document with an auto-generated ID.
        doc_ref = db.collection(collection_name).document()
        # Set the document data.
        doc_ref.set(doc)
        print(f"Uploaded {collection_name[:-1]}: {doc['title']}")

if __name__ == "__main__":
    # Upload articles.
    upload_documents("articles", articles)

    # Upload advices.
    upload_documents("advices", advices)

    print("Data upload complete!")
