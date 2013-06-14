Crypto = function(input) {
	this.input = input

	this.normalizePlaintext = function() {
		return input.toLowerCase().replace(/[^a-zA-Z0-9]/g,'');
	}

	this.size = function() {
		var realLength = Math.sqrt(this.normalizePlaintext().length);
		return Math.ceil(realLength);
	}

	this.plaintextSegments = function() {
		var plainText = this.normalizePlaintext();
		var chunkSize = this.size();

		var splitRegex = new RegExp(".{1," + chunkSize + "}","g");
		return plainText.match(splitRegex);
	}

	this.ciphertext = function() {
		var textSegments = this.plaintextSegments();

		var columns = [];

		for (var i = 0; i < this.size(); i++) {
			columns.push([]);
		};

		for (var i = 0; i < textSegments.length; i++) {
			var currentSegment = textSegments[i];
			
			for (var j = 0; j < currentSegment.length; j++) {
				var currentLetter = currentSegment[j];
				columns[j].push(currentLetter);	
			};
		};

		for (var i = 0; i < columns.length; i++) {
			columns[i] = columns[i].join("");
		};

		return columns.join("");
	}

	this.normalizeCiphertext = function() {
		return this.ciphertext().match(/.{1,5}/g).join(" ");
	}
}
