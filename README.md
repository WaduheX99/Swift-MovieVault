# 🎬 Movie Vault

**Movie Vault** is an iOS application that showcases a wide range of movie information, including popular titles, top-rated films, trending picks, and upcoming releases. All data is fetched from [The Movie Database (TMDB)](https://www.themoviedb.org/), offering users a sleek and immersive movie discovery experience.

## 🔑 Setting Up the TMDB API Key

To run this project, you will need an API key from TMDB. Follow these steps to add it to the project:

1. Navigate to the `Secrets.swift` file in the project directory.
2. Replace the placeholder with your actual TMDB API key as shown below:

```swift
struct Secrets {
    static let apiKey = "YOUR_API_KEY_HERE"
}
```
3. Run the app
