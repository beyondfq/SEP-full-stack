using ApplicationCore.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ApplicationCore.ServiceContracts
{
    public interface IMovieService
    {
        // Controllers will call Services

        //List<MovieCardModel> GetTOpRevenueMovies()
        //{
        //    // communicate with Repositories
        //    var movieRepository = new MovieRepository();
        //    var movies = movieRepository.GetTop30HighestRevenueMovies();

        //    var movieCards = new List<MovieCardModel>();
        //    for each (EnvironmentVariableTarget movie in movies)
        //        {
        //        movieCards.Add(new MovieCardModel { Id = movie.Id, Title = movie.Title, PosterUrl = movie.PosterUrl });
        //    }
        //    return movieCards;
        //}

    }
}
