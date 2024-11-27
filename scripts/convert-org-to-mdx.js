const fs = require('fs');
const path = require('path');
const orgParser = require('org-mode-parser');
const matter = require('gray-matter');

const ORG_DIR = path.join(process.cwd(), 'src/content/org-blogs');
const MDX_DIR = path.join(process.cwd(), 'src/content/posts');

// Ensure the output directory exists
if (!fs.existsSync(MDX_DIR)) {
  fs.mkdirSync(MDX_DIR, { recursive: true });
}

// Convert Org-mode content to Markdown
function convertOrgToMarkdown(orgContent) {
  // Basic conversion of common Org-mode syntax to Markdown
  return orgContent
    // Headers
    .replace(/^\*{1,6}\s+/gm, (match) => '#'.repeat(match.trim().length) + ' ')
    // Bold
    .replace(/\*([^*\n]+)\*/g, '**$1**')
    // Italic
    .replace(/\/([^/\n]+)\//g, '*$1*')
    // Code blocks
    .replace(/^\s*#\+BEGIN_SRC\s*([^\n]*)\n([\s\S]*?)\s*#\+END_SRC/gm, '```$1\n$2\n```')
    // Lists
    .replace(/^\s*[-+]\s/gm, '- ')
    // Links
    .replace(/\[\[([^\]]+)\]\[([^\]]+)\]\]/g, '[$2]($1)')
    // Cleanup empty lines
    .replace(/\n{3,}/g, '\n\n');
}

// Extract frontmatter from Org content
function extractFrontmatter(orgContent) {
  const frontmatter = {};
  const lines = orgContent.split('\n');

  for (const line of lines) {
    if (line.startsWith('#+TITLE:')) {
      frontmatter.title = line.replace('#+TITLE:', '').trim();
    } else if (line.startsWith('#+DATE:')) {
      frontmatter.date = line.replace('#+DATE:', '').trim();
    } else if (line.startsWith('#+DESCRIPTION:')) {
      frontmatter.excerpt = line.replace('#+DESCRIPTION:', '').trim();
    }
  }

  // Set default values if not found
  if (!frontmatter.date) {
    frontmatter.date = new Date().toISOString().split('T')[0];
  }
  if (!frontmatter.excerpt) {
    frontmatter.excerpt = frontmatter.title || 'No description provided';
  }

  return frontmatter;
}

// Process a single Org file
function processOrgFile(filePath) {
  const orgContent = fs.readFileSync(filePath, 'utf8');
  const frontmatter = extractFrontmatter(orgContent);

  // Remove frontmatter lines from content
  let content = orgContent
    .split('\n')
    .filter(line => !line.startsWith('#+'))
    .join('\n');

  // Convert to Markdown
  content = convertOrgToMarkdown(content);

  // Create MDX content with frontmatter
  const mdxContent = matter.stringify(content, frontmatter);

  // Generate output filename
  const baseName = path.basename(filePath, '.org');
  const mdxPath = path.join(MDX_DIR, `${baseName}.mdx`);

  // Write MDX file
  fs.writeFileSync(mdxPath, mdxContent);
  console.log(`Converted ${filePath} to ${mdxPath}`);
}

// Process all Org files in the directory
function convertAllOrgFiles() {
  if (!fs.existsSync(ORG_DIR)) {
    console.error(`Directory not found: ${ORG_DIR}`);
    return;
  }

  const files = fs.readdirSync(ORG_DIR);
  const orgFiles = files.filter(file => file.endsWith('.org'));

  if (orgFiles.length === 0) {
    console.log('No Org files found to convert.');
    return;
  }

  orgFiles.forEach(file => {
    const filePath = path.join(ORG_DIR, file);
    processOrgFile(filePath);
  });

  console.log(`Converted ${orgFiles.length} Org files to MDX format.`);
}

// Run the conversion
convertAllOrgFiles(); 