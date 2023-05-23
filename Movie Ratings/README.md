# Individual Project - ML OPS
**_Licensed by: Gustavo Rafael Gonzalez_**

Recently, I was asked to perform a data transformation process and develop an API within a week. Additionally, I was tasked with creating an ML movie recommendation model based on user and movie data. In this README, you will find all the documentation and necessary instructions to use the API that I was requested to develop, along with the access link on **DETA**. I will also provide the corresponding links to the recommendation system deployed on **STREAMLIT** and the notebook related to the model development.

🟣 **MENU:** 🟣

🔹 **Fastapideta** - Folder containing the required packages for API deployment in depa.<br>
🔹 **Raw** - Databases I received to work with.<br>
🔹 **ML_proyecto.ipynb** - Machine Learning project notebook.<br>
🔹 **transformacion.ipynb** - Notebook containing the data ETL (Extract, Transform, Load) work.<br>
🔹 **querys.ipynb** - Notebook containing the query development process.<br>
🔹 **rating_data.parquet** - Dataset containing movie rating records per user.<br>
🔹 **movie_data.csv** - Dataset containing movies from platforms like Netflix, Disney, among others.<br>

## API

🟣 **Access Links** 🟣

🔹 API: https://deta.space/discovery/r/cffsroh2qj7qft8c<br>

🟣 **The functions that compose the API are:** 🟣

🔹 **get_max_duration**: Query for the movie with the longest duration, expressed in minutes or seasons.<br>
🔹 **get_score_count**: Count of movies per platform with a score greater than X value in a given year.<br>
🔹 **get_count_platform**: Count of movies per platform.<br>
🔹 **get_actor**: Display the actor that appears most frequently according to platform and year.<br>


## Machine Learning Model

🟣 **Access Links** 🟣

🔹 Streamlit App: https://gustgv-primer-proyecto-ml-reco-movies-4insnc.streamlit.app/<br>
🔹 Streamlit system repository: https://github.com/Gustgv/Primer-Proyecto-ML.git<br>
🔹 Ratings folder used for model training: https://drive.google.com/drive/folders/1b49OVFJpjPPA1noRBBi1hSmMThXmNzxn<br>

🟣 **Functions of the recommendation system:** 🟣

The function only needs three variables:
* The ID of the user you want to recommend to.
* The ID of the movie you wish to recommend.
* The score you estimate the user will give to the movie if they watch it.

As a result of entering these variables, the system will tell you if the movie is recommended or not, and if recommended, it will estimate the score the user will give.

🟣 **Resources Used:** 🟣

[Streamlit](https://streamlit.io/) - To deploy the recommendation system.<br>
[Deta](https://deta.space/) - To deploy the API.<br>
[SDV Surprise](https://surpriselib.com/) - Library used to implement the ML model.<br>
[Pandas](https://pandas.pydata.org/)