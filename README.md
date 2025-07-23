
# Portfolio Site

This repository hosts the source code for my personal portfolio website, built using the Hugo static site generator. It features a fast and efficient framework to showcase my writing samples, projects, and technical documentation expertise. 

The website highlights my skills in:
- Technical writing for developer and user documentation
- REST API documentation
- Markdown, Git, and version control practices
- Creating and maintaining static websites using Hugo
- Use of GitHub workflows for automating deployments
- Python scripting for automating processes

## Overview

This site uses the [Docsy theme](https://github.com/google/docsy), a responsive and flexible theme optimized for technical documentation. The website is designed to provide clear and structured information with an emphasis on readability and easy navigation.

## Key Features

- **Writing Samples**: A showcase of my professional technical writing projects, including API documentation and user guides.
- **Automated Release Notes**: Integration with GitHub workflows to generate and publish release notes.
- **Responsive Design**: Optimized for viewing on various devices, including desktop, tablet, and mobile.
- **Mermaid Diagrams**: Utilized for visual representations of workflows, providing clear insight into complex technical processes.
- **Markdown Support**: All content is written in Markdown, ensuring a clean and efficient workflow.
  
## Build and Deployment

The site is built with Hugo, a fast and flexible static site generator. The content is structured in markdown and can be easily updated. I leverage GitHub workflows to automate the deployment process, ensuring that new content is published without manual intervention.

### How to Run Locally

To run this site locally for testing or further development, follow these steps:

1. **Install Hugo:**
   Download and install Hugo by following the instructions [here](https://gohugo.io/getting-started/installing/).

2. **Clone this repository:**
   ```bash
   git clone https://github.com/your-username/your-portfolio-repo.git
   cd your-portfolio-repo
   ```

3. **Run Hugo:**
   Start the Hugo server to see the changes live in your browser.
   ```bash
   hugo server
   ```

4. **View the site:**
   Open your browser and navigate to `http://localhost:1313` to view the site locally.

### Deployment

The site is deployed using GitHub Pages. The `publish_dir` is set to the `docs/` directory for smooth integration with GitHub Pages. The process is automated through GitHub workflows, ensuring that the latest updates are reflected on the live site.

## Contributing

If you find any issues or have suggestions for improving the site, feel free to open an issue or submit a pull request. I welcome feedback and contributions to improve the website.
