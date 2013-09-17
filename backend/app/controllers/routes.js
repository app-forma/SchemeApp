/*jslint node: true, plusplus: true, vars: true, maxerr: 200, regexp: true, white: true */

module.exports = function(app) {
  var passport = require('../../config/passport.js');
  // User routes
  var users = require('./users.js');
  app.get('/users', users.index);
  app.get('/users/:id', users.byId);
  app.get('/users/:email', users.byEmail);
  app.get('/users-raw/:id', users.byIdRaw);
  app.post('/users', users.create);
  app.put('/users/:id', users.update);
  app.del('/users/:id', users.destroy);

  /* VG
  app.post('/users', passport.ensureAuthenticated, passport.ensureAdmin(), users.create);
  app.put('/users/:id', passport.ensureAuthenticated, passport.ensureAdmin(), users.update);
  app.del('/users/:id', passport.ensureAuthenticated, passport.ensureAdmin(), users.destroy);
  */

  // EventWrapper routes
  var eventWrappers = require('./eventWrappers.js');
  app.get('/eventWrappers', eventWrappers.index);
  app.get('/eventWrappers/:id', eventWrappers.byId);
  app.get('/eventWrappers-raw/:id', eventWrappers.byIdRaw);
  app.post('/eventWrappers', eventWrappers.create);
  app.post('/eventWrappers/findbydate', eventWrappers.findByDate);
  app.put('/eventWrappers/:id', eventWrappers.update);
  app.del('/eventWrappers/:id', eventWrappers.destroy);

  /* VG
  app.post('/eventWrappers', passport.ensureAuthenticated, passport.ensureAdmin(), eventWrappers.create);
  app.put('/eventWrappers/:id', passport.ensureAuthenticated, passport.ensureAdmin(), eventWrappers.update);
  app.del('/eventWrappers/:id', passport.ensureAuthenticated, passport.ensureAdmin(), eventWrappers.destroy);
  */

  // Event routes
  var events = require('./events.js');
  app.get('/events', events.index);
  app.get('/events/:id', events.byId);
  app.get('/events-raw/:id', events.byIdRaw);
  app.post('/events', events.create);
  app.put('/events/:id', events.update);
  app.del('/events/:id', events.destroy);

  // Messages
  var messages = require('./messages.js');
  app.get('/messages', messages.index);
  app.get('/messages/:id', messages.byId);
  app.get('/messages-raw/:id', messages.byIdRaw);
  app.post('/messages', messages.create);
  app.post('/messages/broadcast', messages.broadcast);
  app.put('/messages/:id', messages.update);
  app.del('/messages/:id', messages.destroy);

/* VG
  app.post('/events', passport.ensureAuthenticated, passport.ensureAdmin(), events.create);
  app.put('/events/:id', passport.ensureAuthenticated, passport.ensureAdmin(), events.update);
  app.del('/events/:id', passport.ensureAuthenticated, passport.ensureAdmin(), events.destroy);
  */

  // Login / logout
  app.get('/logout', users.logout);
  app.post('/login', users.login);

  // Catch all, assume 404
  app.get('/*', function(req, res) {
    res.json(404);
  });
};