import 'package:flutter/material.dart';
import 'package:flutter_movie_db_api/models/movie.dart';
import 'package:flutter_movie_db_api/sevices/movie_services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  // Lista de widgets para las diferentes pantallas
  static final List<Widget> _widgetOptions = <Widget>[
    const MovieListScreen(), // Primera opción muestra la lista de películas
    const Center(
      child: Text(
        'Index 1: Business',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    ),
    const Center(
      child: Text(
        'Index 2: School',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    ),
    const Center(
      child: Text(
        'Index 3: Settings',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex), // Carga la pantalla seleccionada
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late MovieService movieService;
  late Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    movieService = MovieService(
        apiUrl: 'https://api.themoviedb.org/3/movie/upcoming?api_key=81819d9750b41c41923effa77112f27a');
    futureMovies = movieService.fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: futureMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No movies found.'));
        }

        final movies = snapshot.data!;
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return Card(
              elevation: 5,
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: movie.posterPath.isNotEmpty
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        width: 50,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox(width: 50, child: Icon(Icons.movie)),
                title: Text(movie.title),
                subtitle: Text(
                    '${movie.releaseDate} | Rating: ${movie.voteAverage}'),
              ),
            );
          },
        );
      },
    );
  }
}
