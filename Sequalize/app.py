from flask import Flask, jsonify

from datetime import datetime, timedelta

import sqlalchemy
from sqlalchemy import create_engine, func
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session

engine = create_engine("sqlite:///hawaii.sqlite")

Base = automap_base()
Base.prepare(engine, reflect=True)

Measurements = Base.classes.measurements
Stations = Base.classes.stations

session = Session(engine)

app = Flask(__name__)

@app.route("/api/v1.0/precipitation")
def precipitation():
  prcp_last_year = session.query(Measurements.date, Measurements.prcp).filter(Measurements.date >= "2017-01-01", Measurements.date <= "2017-12-31").all()
  return jsonify(dict(prcp_last_year))

@app.route("/api/v1.0/stations")
def stations():
  return jsonify(session.query(Stations.station).all())

@app.route("/api/v1.0/tobs")
def tobs():
  tobs_last_year = session.query(Measurements.date, Measurements.prcp).filter(Measurements.date >= "2017-01-01", Measurements.date <= "2017-12-31").all()
  return jsonify(dict(tobs_last_year))

@app.route("/api/v1.0/<start>")
def start(start):
  result = calc_temps(start, datetime.now().strftime('%Y-%m-%d'))
  return jsonify([{"TMIN": result[0], "TAVG": result[1], "TMAX": result[2]}])

@app.route("/api/v1.0/<start>/<end>")
def startandend(start, end):
  result = calc_temps(start, end)
  return jsonify([{"TMIN": result[0], "TAVG": result[1], "TMAX": result[2]}])

@app.route("/")
def welcome():
  return (
    "Sequalize Homework<br/>"
    "Available Routes:<br/>"
    "/api/v1.0/precipitation<br/>"
    "/api/v1.0/stations<br/>"
    "/api/v1.0/tobs<br/>"
    "/api/v1.0/[start_date]<br/>"
    "/api/v1.0/[start_date]/[end_date]<br/>"
  )

def calc_temps(start_date, end_date):
  s_date = datetime.strptime(start_date, '%Y-%m-%d')
  e_date = datetime.strptime(end_date, '%Y-%m-%d')
  
  result = session.query(func.min(Measurements.tobs), func.avg(Measurements.tobs), func.max(Measurements.tobs))\
  .filter(s_date < Measurements.date, Measurements.date < e_date).all()
  
  return result[0]

if __name__ == "__main__":
    app.run(debug=True)
