/*jslint node: true, plusplus: true, vars: true, maxerr: 200, regexp: true, white: true */

/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
  Event = mongoose.model('Event');


/**
 * List of events
 */
exports.index = function(req, res) {
  Event.list(function(err, events) {
    if (err) return res.json(500, err.errors);
    res.json(200, events);
  });
};

/**
 * Find event by id
 */
exports.event = function(req, res, next, id) {
  Event.load(id, function(err, event) {
    if (err) return next(err);
    if (!event) return next(new Error('Failed to load event ' + id));
    req.event = event;
    next();
  });
};

// create events, should always get an array as input
exports.create = function(req, res) {
  var body = req.body;
  if (body.array && body.array instanceof Array) {
    body = body.array;
    var count = 0,
      resultList = [];
    body.forEach(function(_event, i) {
      var event = new Event(_event);
      event.saveToDisk(event, function(err, event) {
        resultList[i] = err ? false : event._id;
        if (++count === body.length) {
          res.json(200, {
            result: resultList
          });
        }
      });
    });
  } else {
    var event = new Event(req.body);
    event.saveToDisk(event, function(err, event) {
      if (err) {
        res.json(500, err.errors);
      } else {
        res.json(200, event);
      }
    });
  }
};


/**
 * Update a event
 */
exports.update = function(req, res) {
  // Obj can't contain _id. Will generate error.
  delete req.body._id;
  Event.update({
    _id: req.params.id
  }, req.body, {
    upsert: true
  }, function(err, doc) {
    if (err) {
      res.json(500, err);
    } else {
      Event.findOne({
        _id: req.params.id
      }).populate('_eventWrapperId')
        .exec(function(err, doc) {
          if (err) {
            res.json(500, err.errors);
          } else {
            res.json(200, doc);
          }
        });
    }
  });
};

/**
 * Delete a event
 */
exports.destroy = function(req, res) {
  Event.remove({
    _id: req.params.id
  }, function(err) {
    if (err) {
      res.json(500, err.errors);
    } else {
      res.json(200, {
        deleted: true
      });
    }
  });
};

/**
 * Event by id
 */
exports.byId = function(req, res) {
  Event.findOne({
    _id: req.params.id
  }).populate('_eventWrapperId')
    .exec(function(err, doc) {
      if (err) {
        res.json(500, err.errors);
      } else {
        res.json(200, doc);
      }
    });
};

exports.byIdRaw = function(req, res) {
  Event.findOne({
    _id: req.params.id
  }).exec(function(err, doc) {
    if (err) {
      res.json(500, err.errors);
    } else {
      res.json(200, doc);
    }
  });
};