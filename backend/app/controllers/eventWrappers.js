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

exports.create = function (req, res) {
  var eventWrapper = new EventWrapper(req.body);
  eventWrapper.saveToDisk(eventWrapper, function (err, eventWrapper) {
    if (err) {
      res.json(500, err.errors);
    } else {
      res.json(200, eventWrapper);
    }
  });
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
exports.findByDate = function (req, res) {


    EventWrapper.where('startDate').gte(req.body.startDate).lte(req.body.endDate).populate('events')
    .populate('owner').exec(function (err, doc) {
      if (err) {
        res.json(404);
        return;
      } else {

        res.json(200, doc);
      }
    });
  }