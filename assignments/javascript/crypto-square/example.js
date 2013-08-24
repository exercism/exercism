'use strict';

module.exports = function(input) {
	this.input = input;

	this.normalizePlaintext = function() {
		return input.toLowerCase().replace(/[^a-zA-Z0-9]/g,'');
	};

	this.size = function() {
		var realLength = Math.sqrt(this.normalizePlaintext().length);
		return Math.ceil(realLength);
	};

	this.plaintextSegments = function() {
		var plainText = this.normalizePlaintext();
		var chunkSize = this.size();

		var splitRegex = new RegExp(".{1," + chunkSize + "}","g");
		return plainText.match(splitRegex);
	};

	this.ciphertext = function() {
		var textSegments = this.plaintextSegments();
		var i, j;
		var columns = [];
		var currentSegment;
		var currentLetter;

		for (i = 0; i < this.size(); i++) {
			columns.push([]);
		}

		for (i = 0; i < textSegments.length; i++) {
			currentSegment = textSegments[i];
			
			for (j = 0; j < currentSegment.length; j++) {
				currentLetter = currentSegment[j];
				columns[j].push(currentLetter);	
			}
		}

		for (i = 0; i < columns.length; i++) {
			columns[i] = columns[i].join("");
		}

		return columns.join("");
	};

	this.normalizeCiphertext = function() {
		return this.ciphertext().match(/.{1,5}/g).join(" ");
	};
};
