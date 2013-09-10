var passport = require('passport'),
    User = require('../app/models/user.js').User,
    UserCtrl = require('../app/controllers/users.js'),
    Helpers = require('../helpers.js'),
    LocalStrategy = require('passport-local').Strategy;

passport.serializeUser(function(user, done) {
  done(null, user.id);
});

passport.deserializeUser(function(id, done) {
  UserCtrl.byId(id, function (err, user) {
    done(err, user);
  });
});

passport.use(new LocalStrategy(function(email, password, done) {
  User.findOne({ email: email }, function(err, user) {
    if (err) { return done(err); }
    if (!user) { return done(null, false, { message: 'Unknown email ' + email }); }
      if (!Helpers.validateCryptoPassword(password, user.password)) return done(err);
      if(Helpers.validateCryptoPassword(password, user.password)) {
        return done(null, user);
      } else {
        return done(null, false, { message: 'Invalid password' });
      }
  });
}));

// Simple route middleware to ensure user is authenticated.  Otherwise send to login page.
exports.ensureAuthenticated = function ensureAuthenticated(req, res, next) {
  if (req.isAuthenticated()) { return next(); }
  res.send(401); // Unauthorized header
};


// Check for admin middleware
exports.ensureAdmin = function ensureAdmin(req, res, next) {
    return function(req, res, next) {
        if(req.user && req.user.role === 'admin' || req.user.role === 'superadmin')
            next();
        else
            res.send(403); // Forbidden
    };
};