'use strict'

describe('Lambda', () => {
  const LAMBDA  = require('../index');
  const DATA    = require('./data').TEST_RECORDS;

  //before((done) => { });
  //after((done) => { });

  it('Fake Test', (done) => {
    done();
  });

  it('Sends Message', (done) => {
    LAMBDA.handler(DATA, {}, function() {
      done();
    });
  });
});
