using ApplicationCore.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ApplicationCore.RepositoryContracts
{
    public interface IMovieRepository
    {
        // CRUD operations regarding Movie Table
        // use Movie Entity

        // method to get top 30 highest grossing movies

        List<Movie> GetTop30HighestRevenueMovies();

        List<Movie> GetTop30RatedMovies();

        Movie GetById(int id);
    }
}
