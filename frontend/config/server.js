/* Define custom server-side HTTP routes for lineman's development server
 *   These might be as simple as stubbing a little JSON to
 *   facilitate development of code that interacts with an HTTP service
 *   (presumably, mirroring one that will be reachable in a live environment).
 *
 * It's important to remember that any custom endpoints defined here
 *   will only be available in development, as lineman only builds
 *   static assets, it can't run server-side code.
 *
 * This file can be very useful for rapid prototyping or even organically
 *   defining a spec based on the needs of the client code that emerge.
 *
 */

module.exports = {
  drawRoutes: function(app) {
    // notifications require user to be logged in
    // or be using a cli with a valid key

    // get all
    app.get('/api/v1/notifications', function(req, res){
      res.json([
        {
          "_id" : "51dcb40d4a31e7a3cb000010",
          type: "argument",
          unread: true,
          link: "http://localhost:8000/submissions/51dcb40d4a31e7a3cb000011",
          from: "Bob",
        },
        {
          "_id" : "51dcb40d4a31e7a3cb000031",
          type: "nitpick",
          unread: true,
          link: "http://localhost:8000/submissions/51dcb40d4a31e7a3cb00000f",
          from: "Alice",
        },
        {
          "_id" : "51dcb40d4a31e7a3cb000012",
          type: "argument",
          unread: false,
          link:  "http://localhost:8000/submissions/51dcb40d4a31e7a3cb00000f",
          from: "Bob"
        },
      ]);
    });

    // mark a notification as read
    app.put('/api/v1/notifications/:id', function(req, res){
      res.json({ message: "OK, "+req.params.message });
    });

    // delete notification
    app.delete('/api/v1/notifications/:id', function(req, res){
      res.json({ message: "OK, "+req.params.message });
    });
  }
};
