  // //////////////////////////////////|\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  // *-*-*-*-*-*-*-*-*-*-*-* CONFIGURATION FOR EXPRESS -*-*-*-*-*-*-*-*-*-*-*-*-*
  // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\|/////////////////////////////////////////
  var express = require('express');
  module.exports = function(app, config) {

    // ****************************************************************************
    // *-*-*-*-*-*-*-*-*-*-*-*-*-*-* STATIC SERVER -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
    // ****************************************************************************
    // Not used yet if at all...

    // ****************************************************************************
    // *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*- MIDDLEWARE -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
    // ****************************************************************************
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    //http://stackoverflow.com/questions/8378338/what-does-connect-js-methodoverride-do

    // ****************************************************************************
    // *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*- MISC -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
    // ****************************************************************************

    /**
    *   Needed during development
    */
    if (process.env.NODE_ENV === 'development') {
      var allowCrossDomain = function(req, res, next) {
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Methods", "GET, PUT, POST, DELETE");
        res.header("Access-Control-Allow-Headers", "Content-Type, Authorization");
        if (req.method === "OPTIONS") {
          res.send(200);
        } else {
          next();
        }
      };
      app.use(allowCrossDomain);      
    }

    // ****************************************************************************
    // *-*-*-*-*-*-*-*-*-*-*-*-*-*-*- SESSION/COOKIE -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
    // ****************************************************************************
    // ...


    // ****************************************************************************
    // *-*-*-*-*-*-*-*-*-*-*-*-*-*-*- ROUTER & ERRORS -*-*-*-*-*-*-*-*-*-*-*-*-*-*-
    // ****************************************************************************
    //  Needs to be last
    //
    app.use(app.router);
    if (process.env.NODE_ENV === 'development') {
      app.use(express.logger('dev'));
    }
    app.use(function(err, req, res, next) {
      if (process.env.NODE_ENV === 'development') {
        console.error(err.stack);
      }

      /**
       *   Log errors
       */
      if (process.env.NODE_ENV === 'development') {
        console.error(err.stack);
        res.status(500);
      } else {
        // Todo: Add diffrent behavior on production ver.
        res.status(500);
      }
    });

    /**
     *  If no middleware interceptet it's propably a 404
     */
    app.use(function(req, res, next) {
      res.status(404);
    });
  };