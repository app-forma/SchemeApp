var mongoose = require('mongoose'),
  EventWrapper = mongoose.model('EventWrapper');

/**
 * Find eventWrapper by id
 */
exports.eventWrapper = function (req, res, next, id) {
  EventWrapper.load(id, function (err, eventWrapper) {
    if (err) return next(err);
    if (!eventWrapper) return next(new Error('Failed to load eventWrapper ' + id));
    req.eventWrapper = eventWrapper;
    next();
  });
};


// create eventWrapperS = always an array as incoming data
exports.create = function (req, res) {
  var body = req.body;
  if (body instanceof Array) {
    var count = 0,
      resultList = [];
    body.forEach(function (_eventWrapper, i) {
      var eventWrapper = new EventWrapper(_eventWrapper);
      eventWrapper.saveToDisk(eventWrapper, function (err, eventWrapper) {
        resultList[i] = err ? false : true;
        if (++count === body.length) {
          res.json(200, resultList);
        }
      });
    });
  } else {
    res.json(500, {
      error: 'Invalid format'
    });
  }
};

/**
 * Update eventWrapper
 */
exports.update = function (req, res) {
  // Obj can't contain _id. Will generate error.
  delete req.body._id;
  EventWrapper.update({
    _id: req.params.id
  }, req.body, {
    upsert: true
  }, function (err, doc) {
    if (err) {
      res.json(500, err);
    } else {
      res.json(200, doc);
    }
  });
};

/**
 * Delete eventWrapper
 */
exports.destroy = function (req, res) {
  EventWrapper.findOne({
    _id: req.params.id
  }, function (err, doc) {
    if (err) {
      res.json(500, err.errors);
    } else {
      doc.remove();
      res.json(200);
    }
  });
};

/**
 * List of eventWrappers
 */
exports.index = function (req, res) {
  EventWrapper.list(function (err, eventWrappers) {
    if (err) return res.json(500, err.errors);
    res.json(200, eventWrappers);
  });
};

exports.byId = function (req, res) {
  EventWrapper.findOne({
    _id: req.params.id
  }).populate('events')
    .populate('owner')
    .exec(function (err, doc) {
      if (err) {
        res.json(404);
        return;
      } else {
        res.json(200, doc);
      }
    });
};

exports.byIdRaw = function (req, res) {
  EventWrapper.findOne({
    _id: req.params.id
  }).exec(function (err, doc) {
    if (err) {
      res.json(404);
      return;
    } else {
      res.json(200, doc);
    }
  });
};