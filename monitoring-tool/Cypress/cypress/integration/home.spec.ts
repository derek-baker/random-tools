// DOCS: https://docs.cypress.io/api/commands/screenshot.html#Arguments
// DOCS: https://docs.cypress.io/api/commands/screenshot.html#Full-page-captures-and-fixed-sticky-elements
 
describe('The Home Page', () => {
    it('successfully loads', () => {
        cy.visit(
            '/?q=cypress+testing&t=h_&ia=web'
        );

        // When passing fullPage to the capture option, Cypress scrolls the application under test from top to bottom, 
        // takes screenshots at each point and stitches them together. Due to this, elements that are position: fixed or position: sticky 
        // will appear multiple times in the final screenshot. To prevent this, in most cases you can programmatically change the 
        // element to be position: absolute before the screenshot
        // cy.get('#searchForm').invoke('css', 'position', 'absolute')

        const timestamp = (new Date().toISOString()).replace(/:/g, '-');
        cy.screenshot(`${timestamp}`, {capture: 'fullPage'});
    });
});