// The structure of events: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-event-structure.html#example-viewer-request
function handler(event, context, callback) {
  const request = event.Records[0].cf.request;
  const originalUri = request.uri;
  console.log("Handing request on", originalUri);
  console.log("Headers are", request.headers);
  const lastPart = originalUri.substring(originalUri.lastIndexOf("/") + 1);
  if (lastPart.length > 0 && lastPart.indexOf(".") == -1) {
    // If there is a final part of the URL with no file extension, it's probably a page (HTML)
    request.uri = originalUri + ".html";
  }
  return callback(null, request);
}

module.exports = {
  handler,
};
