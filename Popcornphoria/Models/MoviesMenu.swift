//
//  MoviesMenu.swift
//  Popcornphoria
//
//  Created by Gurditta Singh on 24/03/24.
//

import Foundation

enum MoviesMenu: Int, Identifiable, CaseIterable {
   var id: String {
      self.title
   }

   case nowPlaying, upcoming, trending, popular, topRated

   var title: String {
      switch self {
      case .popular: return "Popular"
      case .topRated: return "Top Rated"
      case .upcoming: return "Upcoming"
      case .nowPlaying: return "Now Playing"
      case .trending: return "Trending"
      }
   }

   var endpoint: String {
      switch self {
      case .nowPlaying: return "movie/now_playing"
      case .popular: return "movie/popular"
      case .topRated: return "movie/top_rated"
      case .trending: return "trending/movie/day"
      case .upcoming: return "movie/upcoming"
      }
   }
}
