/*jslint node: true, plusplus: true, vars: true, maxerr: 200, regexp: true, white: true */

module.exports = function(app) {
  var passport = require('../../config/passport.js');
  // User routes
  var users = require('./users.js');
  app.get('/users', users.index);
  app.get('/users/:id', users.byId);
  app.get('/users/email/:email', users.byEmail);
  app.get('/users-raw/:id', users.byIdRaw);
  app.post('/users', users.create);
  app.put('/users/:id', users.update);
  app.del('/users/:id', users.destroy);
  app.post('/users/login', users.login);

  app.post('/users/:id/attendance/:date', users.addAttendance);
  app.del('/users/:id/attendance/:date', users.removeAttendance);


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
  app.post('/eventWrappers', eventWrappers.create, passport.ensureAuthenticated);
  app.post('/eventWrappers/findbydate', eventWrappers.findByDate);
  app.put('/eventWrappers/:id', eventWrappers.update, passport.ensureAuthenticated);
  app.del('/eventWrappers/:id', eventWrappers.destroy, passport.ensureAuthenticated);

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
  app.post('/events', events.create, passport.ensureAuthenticated);
  app.put('/events/:id', events.update, passport.ensureAuthenticated);
  app.del('/events/:id', events.destroy, passport.ensureAuthenticated);

  // Messages
  var messages = require('./messages.js');
  app.get('/messages', messages.index);
  app.get('/messages/:id', messages.byId);
  app.get('/messagesforuser/:id', messages.forUser);
  app.get('/messages-raw/:id', messages.byIdRaw);
  app.post('/messages', messages.create, passport.ensureAuthenticated);
  app.post('/messages/broadcast', messages.broadcast, passport.ensureAuthenticated);
  app.put('/messages/:id', messages.update, passport.ensureAuthenticated);
  app.del('/messages/:id', messages.destroy, passport.ensureAuthenticated);

    // Locations
  var locations = require('./locations.js');
  app.get('/locations', locations.index);
  app.get('/locations/:id', locations.byId);
  app.post('/locations', locations.create, passport.ensureAuthenticated);
  app.put('/locations/:id', locations.update, passport.ensureAuthenticated);
  app.del('/locations/:id', locations.destroy, passport.ensureAuthenticated);

/* VG
  app.post('/events', passport.ensureAuthenticated, passport.ensureAdmin(), events.create);
  app.put('/events/:id', passport.ensureAuthenticated, passport.ensureAdmin(), events.update);
  app.del('/events/:id', passport.ensureAuthenticated, passport.ensureAdmin(), events.destroy);
  */

  // Login / logout
  app.get('/logout', users.logout);

  // Catch all, assume 404
  app.get('/*', function(req, res) {
    res.json(404);
  });
};