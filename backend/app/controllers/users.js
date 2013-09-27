/**
 * Module dependencies.
 */
var mongoose = require('mongoose'),
    Helpers = require('../../helpers.js'),
    User = mongoose.model('User'),
    EventWrapper = mongoose.model('EventWrapper'),
    Message = mongoose.model('Message'),
    passport = require('passport');


/**
 * List of users
 */
exports.index = function (req, res) {
    User.list(function (err, users) {
        if (err) return res.json(500, err.errors);
        res.json(200, users);
    });
};

/**
 * Find item by id
 */
exports.user = function (req, res, next, id) {
    User.load(id, function (err, user) {
        if (err) return next(err);
        if (!user) return next(new Error('Failed to load user ' + id));
        req.user = user;
        next();
    });
};

exports.create = function (req, res) {
    console.log(req.body);
    var user = new User(req.body);
    if (typeof req.body.password === 'string') {
        user.password = Helpers.generateCryptoPassword(user.password);
        user.saveToDisk(user, function (err, user) {
            if (err) {
                console.log(err);
                res.json(500, err.errors);
            } else {
                console.log(err);
                console.log(user);
                res.json(200, user);
            }
        });
    } else {
        res.json(500);
    }
};


/**
 * Update a user
 */
exports.update = function (req, res) {
    // Obj can't contain _id. Will generate error.
    delete req.body._id;
    User.update({
        _id: req.params.id
    }, req.body, {
        upsert: true
    }, function (err, doc) {
        if (err) {
            res.json(500, err);
        } else {
            User.findOne({
                _id: req.params.id
            }).populate('eventWrappers').populate('messages')
                .exec(function (err, doc) {
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
 * Delete a user
 */
exports.destroy = function (req, res) {
    User.remove({
        _id: req.params.id
    }, function (err) {
        if (err) {
            res.json(500, err.errors);
        } else {
            res.json(200);
        }
    });
};

/**
 * User by id
 */
exports.byId = function (req, res) {
    User.findOne({
        _id: req.params.id
    }).populate('eventWrappers').populate('messages')
        .exec(function (err, doc) {
            if (err) {
                res.json(500, err.errors);
            } else {
                res.json(200, doc);
            }
        });
};

exports.byIdRaw = function (req, res) {
    User.findOne({
        _id: req.params.id
    }).exec(function (err, doc) {
        if (err) {
            res.json(500, err.errors);
        } else {
            res.json(200, doc);
        }
    });
};
var populateMessagesToUser = function (messages, callback) {
    Message.find({
        _id: {
            $in: messages
        }
    }).populate('from').exec(function (err, doc) {
        if (err) {
            callback(null, err);
        } else {
            callback(doc, null);
        }
    });

};
var populateEventWrappersToUser = function (eventWrappers, callback) {
    EventWrapper.find({
        _id: {
            $in: eventWrappers
        }
    }).populate('owner').populate('events').exec(function (err, doc) {
        if (err) {
            callback(null, e);
        } else {
            callback(doc, null);

        }
    });
};
exports.byEmail = function (req, res) {
    User.findOne({
        email: req.params.email
    }).populate('messages').populate('eventWrappers')
        .exec(function (err, doc) {
            if (err) {
                res.json(500, err.errors);
            } else {
                if (doc !== null) {
                    populateEventWrappersToUser(doc.eventWrappers, function (evntwrps, e) {
                        if (e) {
                            console.log(e);
                        } else {
                            doc.eventWrappers = evntwrps;
                        }
                        if (doc.messages.length > 0) {
                            populateMessagesToUser(doc.messages, function (msgs, err) {
                                if (err) {
                                    console.log(err);
                                } else {
                                    doc.messages = msgs;
                                    res.json(200, doc);
                                }
                            });
                        } else {
                            res.json(200, doc);
                        }
                    });
                } else {
                    res.send(404);
                }
            }
        });
};

exports.addAttendance = function (req, res) {
    User.findOne({
        _id: req.params.id
    }).exec(function (err, user) {
        if (err) {
            res.json(500, err.errors);
        } else {
            var foundDuplicate = false;
            for (var i = 0; i < user.attendances.length; i++) {
                if (req.params.date === user.attendances[i]) {
                    foundDuplicate = true;
                    break;
                }
            }
            if (!foundDuplicate) {
                user.attendances.push(req.params.date);
                user.save(function (err) {
                    if (err) {
                        res.json(500, err.errors);
                        return;
                    }
                });
            }
            res.json(200, {
                added: true
            });
        }
    });
};

exports.removeAttendance = function (req, res) {
    User.findOne({
        _id: req.params.id
    }).exec(function (err, user) {
        if (err) {
            res.json(500, err.errors);
        } else {
            console.log(req.params.date);
            if (req.params.date) {
                var deletions = 0;
                var newArray = [];
                for (var i = 0; i < user.attendances.length; i++) {
                    if (req.params.date !== user.attendances[i]) {
                        newArray.push(user.attendances[i]);
                    } else {
                        deletions++;
                    }
                }
                user.attendances = newArray;
                user.save(function (err) {
                    if (err) {
                        res.json(500, err.errors);
                    } else if (deletions > 0) {
                        res.json(200, {
                            deletions: deletions
                        });
                    } else {
                        res.json(500, {
                            error: "no deletions"
                        });
                    }
                });
            } else {
                res.json(500, {
                    error: "invalid data"
                });
            }
        }
    });
};


/**
 *   Compare test to hashed password
 */
exports.comparePasswords = function (password, passwordHash) {
    return Helpers.validateCryptoPassword(password, passwordHash);
};

/**
 *   Authentication
 */
exports.byEmailPassport = function (email, cb) {
    User.findOne({
        email: email
    }).exec(function (err, doc) {
        cb(err, doc)
    });
};

exports.login = function (req, res, next) {
    user = req.body;
    user.username = req.body.email;
    passport.authenticate('local', function (err, user, info) {
        if (err) {
            return next(err);
        }
        if (!user) {
            return res.json(401, info);
        }
        req.logIn(user, function (err) {
            if (err) {
                return next(err);
            }
            User.findOne({
                _id: user._id
            }).populate('messages')
            .exec(function (err, doc) {
                if (err) {
                    res.json(500, err.errors);
                } else {
                    res.json(200, doc);
                }
            });
            //return res.json(200, user);
        });
    })(req, res, next);
};

exports.logout = function (req, res) {
    req.logout();
    res.send(200);
};