module.exports = function(app) {

  // User routes
  var users = require('./users.js');
  app.get('/users', users.index);
  app.get('/users/:id', users.byId);
  app.post('/users', users.create);
  app.put('/users/:id', users.update);
  app.del('/users/:id', users.destroy);

  // EventWrapper routes
  var eventWrappers = require('./eventWrappers.js');
  app.get('/eventWrappers', eventWrappers.index);
  app.get('/eventWrappers/:id', eventWrappers.byId);
  app.post('/eventWrappers', eventWrappers.create);
  app.put('/eventWrappers/:id', eventWrappers.update);
  app.del('/eventWrappers/:id', eventWrappers.destroy);

  // Event routes
  var events = require('./events.js');
  app.get('/events', events.index);
  app.get('/events/:id', events.byId);
  app.post('/events', events.create);
  app.put('/events/:id', events.update);
  app.del('/events/:id', events.destroy);

  // Catch all, assume 404
  app.get('/*', function(req, res) {
    res.json(404);
  });
};