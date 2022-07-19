using Microsoft.AspNetCore.Mvc;
using MovieShopMVC.Models;
using System.Diagnostics;

namespace MovieShopMVC.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            // Home Page
            // Top 30 Highest grossing Movies
            // go to database and get 30 movies
            // List<Movie>
            // we need to send the model data to the View
            // Controllers will call Services, which are gonna call Repositories
            // ppassing data from Controller/action methods to Views, through C# Models

            //var movieService = new MovieService();
            //var movieCards = movieService.GetTopRevenueMovies();
            //return View(movieCards);
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        public IActionResult TopRatedMovies()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}