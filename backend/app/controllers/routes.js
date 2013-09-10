module.exports = function(app) {
  var passport = require('../../config/passport.js');
  // User routes
  var users = require('./users.js');
  app.get('/users', users.index);
  app.get('/users/:id', users.byId);
  app.get('/users-raw/:id', users.byIdRaw);
  app.post('/users', passport.ensureAuthenticated, passport.ensureAdmin(), users.create);
  app.put('/users/:id', passport.ensureAuthenticated, passport.ensureAdmin(), users.update);
  app.del('/users/:id', passport.ensureAuthenticated, passport.ensureAdmin(), users.destroy);

  // EventWrapper routes
  var eventWrappers = require('./eventWrappers.js');
  app.get('/eventWrappers', eventWrappers.index);
  app.get('/eventWrappers/:id', eventWrappers.byId);
  app.get('/eventWrappers-raw/:id', eventWrappers.byIdRaw);
  app.post('/eventWrappers', passport.ensureAuthenticated, passport.ensureAdmin(), eventWrappers.create);
  app.put('/eventWrappers/:id', passport.ensureAuthenticated, passport.ensureAdmin(), eventWrappers.update);
  app.del('/eventWrappers/:id', passport.ensureAuthenticated, passport.ensureAdmin(), eventWrappers.destroy);

  // Event routes
  var events = require('./events.js');
  app.get('/events', events.index);
  app.get('/events/:id', events.byId);
  app.get('/events-raw/:id', events.byIdRaw);
  app.post('/events', passport.ensureAuthenticated, passport.ensureAdmin(), events.create);
  app.put('/events/:id', passport.ensureAuthenticated, passport.ensureAdmin(), events.update);
  app.del('/events/:id', passport.ensureAuthenticated, passport.ensureAdmin(), events.destroy);

  // Login / logout
  app.get('/logout', users.logout); 
  app.post('/login', users.login);

  // Catch all, assume 404
  app.get('/*', function(req, res) {
    res.json(404);
  });
};