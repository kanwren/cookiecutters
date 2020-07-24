import "mocha";
import * as fc from "fast-check";

describe("reverse", () => {
    it("should roundtrip", () => {
        fc.assert(fc.property(fc.array(fc.integer()), arr => {
            const copy = [...arr];
            arr.reverse().reverse();
            if (arr.length !== copy.length) {
                return false;
            }
            for (let i = 0; i < arr.length; i++) {
                if (arr[i] !== copy[i]) {
                    return false;
                }
            }
            return true;
        }));
    });
});

