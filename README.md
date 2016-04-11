Informal repository for DITA test case documents
================================================

This repository is a place to capture DITA test case documents
for whatever aspect of DITA you want to test.

The test case catalog is published as HTML here: 

http://www.dita-community.org/dita-test-cases/

This is NOT any sort of official set of test cases. It has
absolutely no affiliation with the OASIS Open DITA Technical Committee.
It's just a convenient place to capture tests that will be of 
general interest.

Please feel free to contribute additional test cases via pull
request.

Test cases should be as small as possible and self-describing so
it's clear from the files what is being tested and what the
expected result is. The test case should refer to the parts
of the DITA specification it is testing. 

The DITA specification is hosted here:

http://docs.oasis-open.org/dita/dita/v1.3/os/

For references to the Architecture Specification, use the
base edition: 

http://docs.oasis-open.org/dita/dita/v1.3/os/part1-base/archSpec/archSpec-base.html

You can view and edit the test documents using OxygenXML's Web editor GitHub integration. If you don't have write access to this repository the editor will automatically create a fork of this respository to save your changes in. You can then use GitHub's pull request feature to easily submit your changes as a pull request.

https://www.oxygenxml.com/webapp-demo-aws/app/oxygen.html?gh_repo=dita-community/dita-test-cases&gh_branch=master&gh_ditamap=test-case-catalog.ditamap

The test-case-catalog DITA map organizes all the test cases. In addition, each test case has one or more root maps for those test cases.

To generat the project GitHub pages for this repository using Docker, do the following:

1. In the same parent directory as your clone of dita-test-cases, clone the dita-test-case project to
the directory "dita-test-cases_gh-pages" and check out that clone to the branch "gh-pages"
2. Execute this docker command (correct for OS X, may need adjustment for Windows): 
    
    ```
    docker run  -v `pwd`/..:/opt/dita-ot/data \
    ditaot/dita-ot \
    dita -i /opt/dita-ot/data/dita-test-cases/test-case-catalog.ditamap \
    -f xhtml \
    -o /opt/dita-ot/data/dita-test-cases_gh-pages \
    -v
    ``` 

3. Commit the updates to the gh-pages project and push to github