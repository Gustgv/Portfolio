from fastapi import FastAPI
import pandas as pd
from typing import Optional

app = FastAPI()

#http://127.0.0.1:8000/

# ---------- Presentacion ----------

@app.get('/')
def presentacion():
    return 'Proyecto Individual -- Gonzalez Villalobos, Gustavo Rafael'

@app.get('/contacto')
def contacto():
    return 'Correo Electronico: gustgv1@gmail.com / Github: Gustgv'

@app.get("/menu")
def menu():
    return '''get_max_duration: Película con mayor duración con filtros opcionales de AÑO, PLATAFORMA Y TIPO DE DURACIÓN
              get_score_count: Cantidad de películas por plataforma con un puntaje mayor a "x" en determinado año
              get_count_platform: Cantidad de películas por plataforma con filtro de PLATAFORMA.
              get_actor: Actor que más se repite según plataforma y año.  '''



# ---------- Queries ----------

# Película con mayor duración con filtros opcionales de AÑO, PLATAFORMA Y TIPO DE DURACIÓN.

@app.get('/get_max_duration')

async def get_max_duration(year: int = 2021 , platform: str = 'amazon' , duration_type: str = 'min'):
    # Lectura de base de datos
    movie_score = pd.read_csv('https://raw.githubusercontent.com/Gustgv/Proyecto-ML_OPS-Gustavo-Gonzalez/master/movie_data.csv')

    # query
    filters = movie_score[['id','title', 'release_year', 'duration_int', 'duration_type', 'score']].loc[(movie_score['release_year'] == year) & (movie_score['platform'] == platform) & (movie_score['duration_type'] == duration_type)]
    filters = filters.sort_values('duration_int', ascending= False).head(1)

    # Utilizo try para que al momento de que no encuentre valores lo exprese en return.
    try:
        return f'{filters.iloc[0,1]} del año {filters.iloc[0,2]}, es la pelicula con mayor duracion, teniendo {filters.iloc[0,3]} {filters.iloc[0,4]} de duracion'
    except:
        return 'No existen valores para esta busqueda'
    



# Cantidad de películas por plataforma con un puntaje mayor a X valor en determinado año

@app.get('/get_score_count/{platform}/{scored}/{year}')

def get_score_count(platform: str, scored: float, year: int):
    # Lectura de base de datos
    movie_score = pd.read_csv('https://raw.githubusercontent.com/Gustgv/Proyecto-ML_OPS-Gustavo-Gonzalez/master/movie_data.csv')
   
    # query
    result = movie_score[['platform', 'score']].loc[(movie_score['platform'] == platform ) & (movie_score['score'] >= scored) & (movie_score['release_year'] == year)].groupby('platform').count()
    
    # Utilizo try para que al momento de que no encuentre valores lo exprese en return.
    try:
        return f'Peliculas en {platform} en el año  {year} y que superan los {scored} puntos: {result.iloc[0, 0]} peliculas'
    except IndexError:
        return 'No existen valores para esta busqueda'
    


# Cantidad de películas por plataforma con filtro de PLATAFORMA.

@app.get('/get_count_platform/{platform}')
def get_count_platform(platform: str):
    
    # Lectura de base de datos
    movie_score = pd.read_csv('https://raw.githubusercontent.com/Gustgv/Proyecto-ML_OPS-Gustavo-Gonzalez/master/movie_data.csv')

    # query
    cuenta = movie_score[['platform', 'score']].loc[(movie_score['platform'] == platform)].groupby('platform').count()
    
    # Utilizo try para que al momento de que no encuentre valores lo exprese en return.
    try:
        return f'Cantidad de peliculas en {platform}: {cuenta.iloc[0, 0]} peliculas'
    except:
        return 'No existen valores para esta busqueda'
    

# Actor que más se repite según plataforma y año.

@app.get('/get_actor/{platform}/{year}')
def get_actor(platform: str, year: int):

    # Lectura de base de datos
    movie_score = pd.read_csv('https://raw.githubusercontent.com/Gustgv/Proyecto-ML_OPS-Gustavo-Gonzalez/master/movie_data.csv')


    # query
    year_plat = movie_score['cast'].loc[(movie_score['platform'] == platform) & (movie_score['release_year'] == year)]
    cast = year_plat.str.split(',', expand= True)
    cast = pd.melt(cast)
    cast = cast['value'].dropna()
    result = cast.value_counts().head(1).reset_index(drop= False)
    
    # Utilizo try para que al momento de que no encuentre valores lo exprese en return.
    try:
        return f'El actor que mas se repite en el año {year} por {platform}: {result.iloc[0,0]}'
    except:
        return 'No existen valores para esta busqueda'
